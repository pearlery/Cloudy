import "controllers"

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = true

import * as Rails from './rails-ujs';
Rails.start();

import "bootstrap"

