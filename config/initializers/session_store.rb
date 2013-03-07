# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

Jokels::Application.config.session_store :cookie_store, :key => '_jokels_session1'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Jokels::Application.config.session_store :active_record_store
