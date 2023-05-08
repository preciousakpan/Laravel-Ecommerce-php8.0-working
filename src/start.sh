#!/bin/bash

php artisan migrate
php artisan db:seed --class=UserSeeder
php artisan db:seed --class=UserRoleSeeder
php artisan db:seed --class=DatabaseSeeder
php-fpm
# php artisan serve
