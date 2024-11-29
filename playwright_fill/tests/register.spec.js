const { test, expect } = require('@playwright/test');

test('register success', async ({ page }) => {
    await page.goto('https://cloudyvibeboard.onrender.com/posts');
    // await expect(page.getByTestId('loginLink')).toBeEnabled(true);
    await page.getByTestId('loginLink').click();
    await page.getByTestId('email').fill('rubysohard@gmail.com');
    await page.getByTestId('email').press('Tab');
    await page.getByTestId('password').fill('hardhardhard');
    await page.getByTestId('name').fill('Uncle Ruby');
    await page.getByTestId('submit').click();
    // await expect(page.getByText('User Create:')).toBeVisible();
});