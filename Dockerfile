# syntax = docker/dockerfile:1

# ใช้ Ruby image ที่ต้องการ
ARG RUBY_VERSION=3.3.0
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# กำหนด working directory
WORKDIR /rails

# ติดตั้ง base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ตั้งค่า environment สำหรับ production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ใช้ stage build เพื่อลดขนาด image
FROM base AS build

# ติดตั้ง packages ที่จำเป็นสำหรับการ build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# คัดลอก Gemfile และ Gemfile.lock มาติดตั้ง dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# คัดลอก application code
COPY . .

# Precompile bootsnap code สำหรับการบู๊ตเร็วขึ้น
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets สำหรับ production โดยไม่ต้องใช้ RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage สำหรับ app image
FROM base

# คัดลอก gems และ application มาจาก build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# สร้าง user ใหม่เพื่อเพิ่มความปลอดภัยในการใช้งาน
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

# ตั้ง entrypoint สำหรับการเตรียมฐานข้อมูล
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# เปิด port 3000 สำหรับ Rails server
EXPOSE 3000

# เริ่มต้น server
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
