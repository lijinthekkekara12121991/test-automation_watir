# frozen_string_literal: true

require "securerandom"
require "watir"
require "webdrivers"

Before do |scenario|
  time = Time.now
  browser_setup(headless: false)
end

After do |scenario|
  time = Time.now
  screenshot_on_fail scenario
  browser_teardown
  print_teardown time
end

Around do |scenario, block|
  # timing out Scenarios which run longer than 1800s = 30m
  Timeout.timeout(1800) do
    block.call
  end
end

def webdriver_prefs
  {
    download: {
      prompt_for_download: false,
      default_directory: Dir.chdir("#{Dir.pwd.gsub('/assets/downloads', '')}/assets/downloads")
    }
  }
end

def webdriver_args(headless:)
  ["--headless"] if headless
end

def browser_setup(headless:)
  @browser = Watir::Browser.new :chrome, options: { prefs: webdriver_prefs, args: webdriver_args(headless: headless) }
  $browser_is_headless = headless
  if headless
    @browser.window.resize_to(4096, 2160) # 4K, baby!
  else
    @browser.window.maximize
  end
end

def browser_teardown
  @browser.close
end

def print_setup(time)
  log "
  •••> #{Time.now.gmtime} (Setup: #{(Time.now - time).round(2)}s) #{@customer_name.slice(0, 14)}.. on #{ENV['APP_HOST']
  .gsub('https://', '').gsub('.riskmethods.net', '').upcase}
  "
end

def print_teardown(time)
  log "
  •••> #{Time.now.gmtime} (Teardown: #{(Time.now - time).round(2)}s)
  "
end

def screenshot_on_fail(scenario)
  return unless scenario.failed?

  time = Time.now.to_s.gsub(":", "-").gsub(" ", "-")[0...-6] # format timestamp nicer
  scenario_name = scenario.name.gsub(" ", "_").gsub(%r{[^0-9A-Za-z_]}, "") # format scenario name
  screenshot_file = "#{Dir.pwd.gsub('/downloads', '')}/screenshots/#{time}-FAILED_#{scenario_name}.png"
  @browser.driver.save_screenshot(screenshot_file)
end
