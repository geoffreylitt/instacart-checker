require 'json'
require 'terminal-notifier'

require 'optparse'

# an example response where delivery slots were available, for testing purposes
AVAILABLE_SAMPLE = {"container"=>{"title"=>"Market Basket Information", "path"=>"market-basket/next_gen/retailer_information/content/delivery?source=web", "initial_step"=>nil, "modules"=>[{"id"=>"icon_info_6d54d2bf7f936a86", "data"=>{"icon"=>"info", "text_formatted"=>{"strings"=>[{"value"=>"Prices listed for orders $35 and above per store.", "attributes"=>[]}, {"value"=>" High demand is impacting available delivery windows. When you choose Fast & Flexible, you'll have your order taken by the first available shopper. We'll keep you updated on your order.", "attributes"=>["bold"]}], "action"=>nil, "alt"=>nil}}, "absolute_position"=>nil, "tracking_params"=>{}, "tracking_event_names"=>{}, "types"=>["icon_info"], "layouts"=>["main"], "steps"=>[], "step_transitions"=>{}, "async_data_path"=>nil, "async_data_dependencies"=>[], "public_rollbar_token"=>"0b85f4d3badf4de4843377f16b2bf094"}, {"id"=>"delivery_option_list_370f26ce24644f81", "data"=>{"header"=>nil, "tracking_event_names"=>{"click_view_more"=>"click_view_more"}, "tracking_params"=>{"source1"=>"delivery", "service_type"=>"delivery"}, "service_options"=>{"type"=>"premium", "title"=>nil, "banner"=>nil, "action"=>nil, "tracking_params"=>{"delivery_options"=>[{"id"=>133713188, "available_ind"=>true, "delivery_fee"=>3.99, "surge_ind"=>false, "exposed_ind"=>true, "alcohol_block"=>false, "starts_at"=>"2020-04-26T13:00:00.000-04:00", "ends_at"=>"2020-04-28T13:00:00.000-04:00"}]}, "service_options"=>{"price_minimum"=>nil, "options_explanation"=>nil, "days"=>[{"day"=>"Fast & Flexible", "day_full"=>"Fast & Flexible", "date"=>nil, "options"=>[{"id"=>"133713188", "window"=>"Apr 26 - Apr 28", "full_window"=>"Apr 26 - Apr 28", "delivery_full_window"=>"Delivery Apr 26 - Apr 28", "green_window"=>"Apr 26 - Apr 28", "service_tag"=>nil, "price"=>"$3.99", "full_price"=>nil, "additional_price_information"=>nil, "price_value"=>3.99, "last_pickup"=>nil, "pickup_full_window"=>nil, "description"=>nil, "attributes"=>["available", "normal", "first_available"], "price_color"=>"#757575", "option_type"=>"AsapDeliveryOption", "green_attribute"=>nil}], "date_full"=>"Fast & Flexible", "message"=>[{"strings"=>[{"value"=>"Demand is higher than normal. When you choose", "attributes"=>[]}, {"value"=>" \"Fast & Flexible\",", "attributes"=>["bold"]}, {"value"=>" your order will be taken once a shopper is available.", "attributes"=>[]}], "action"=>nil, "alt"=>nil}]}], "availability_id"=>"0b422f4f-b525-4b6d-a676-1f8f58437504", "unattended_delivery_message"=>nil, "express_placement"=>nil, "selected_service_date"=>nil, "alcohol_blocked"=>false, "next_available_date"=>nil, "service_allowed_hours_by_date"=>nil, "viewed_options_count"=>0, "alcohol_compliance_required"=>false, "error_module"=>nil, "shipping_options"=>nil}}}, "absolute_position"=>nil, "tracking_params"=>{"source1"=>"delivery", "service_type"=>"delivery"}, "tracking_event_names"=>{"click_view_more"=>"click_view_more"}, "types"=>["service_option_list"], "layouts"=>["main"], "steps"=>[], "step_transitions"=>{}, "async_data_path"=>nil, "async_data_dependencies"=>[], "public_rollbar_token"=>"0b85f4d3badf4de4843377f16b2bf094"}], "attributes"=>[], "async_data_path"=>nil, "tracking_params"=>{"product_flow"=>"store", "source_type"=>"delivery", "source_value"=>"e759130e-d212-4f81-b9a6-6fdceafd497d", "retailer_info_version"=>2, "page_view_id"=>"e759130e-d212-4f81-b9a6-6fdceafd497d"}, "tracking_event_names"=>{"view"=>"retailer_delivery_times", "close"=>"dismiss"}, "public_rollbar_token"=>"0b85f4d3badf4de4843377f16b2bf094", "data_dependencies"=>[], "image"=>nil, "images"=>[]}, "meta"=>{"triggered_action"=>nil, "analytics_actions"=>[], "cache_ttl"=>30}}

UNAVAILABLE_SAMPLE = {"container"=>{"title"=>"Market Basket Information", "path"=>"market-basket/next_gen/retailer_information/content/delivery?source=web", "initial_step"=>nil, "modules"=>[{"id"=>"errors_no_availability_27929a1b145be4ffdb8c10d9e4a36026", "data"=>{"image"=>{"url"=>"https://d2guulkeunn7d8.cloudfront.net/assets/modules/errors/heavy_load-9c583d42cc391f1ade7b077ef715e4c389741570579585b13ee7a27b169905b4.png", "alt"=>"All delivery windows are full"}, "responsive_image"=>{"url"=>"https://d2guulkeunn7d8.cloudfront.net/assets/modules/errors/heavy_load-9c583d42cc391f1ade7b077ef715e4c389741570579585b13ee7a27b169905b4.png", "alt"=>" ", "responsive"=>{"template"=>"https://d2d8wwwkmhfcva.cloudfront.net/{width}x/d2guulkeunn7d8.cloudfront.net/assets/modules/errors/heavy_load-9c583d42cc391f1ade7b077ef715e4c389741570579585b13ee7a27b169905b4.png", "defaults"=>{"width"=>120}}, "sizes"=>[]}, "title"=>"All delivery windows are full", "formatted_title"=>nil, "description_lines"=>["Due to COVID-19, there's higher demand than normal. Thanks for your patience as we work to create more availability. Please check again soon."], "formatted_description_lines"=>nil, "primary_action"=>nil, "tracking_event_names"=>{}}, "types"=>["error"], "layouts"=>["main"], "steps"=>[], "step_transitions"=>{}, "async_data_path"=>nil, "async_data_dependencies"=>[], "public_rollbar_token"=>"21a36f0055824e469ab83c73ded03922"}], "attributes"=>[], "async_data_path"=>nil, "tracking_params"=>{"product_flow"=>"store", "source_type"=>"delivery", "source_value"=>"a882b068-2d82-402d-85b3-a408a616b9e0", "retailer_info_version"=>2, "page_view_id"=>"a882b068-2d82-402d-85b3-a408a616b9e0"}, "tracking_event_names"=>{"view"=>"retailer_delivery_times", "close"=>"dismiss"}, "public_rollbar_token"=>"0b85f4d3badf4de4843377f16b2bf094", "data_dependencies"=>[], "image"=>nil, "images"=>[]}, "meta"=>{"triggered_action"=>nil, "analytics_actions"=>[], "cache_ttl"=>30}}

def check(test: false)
  puts "Checking delivery slots... #{Time.now}"

  curl = File.open("curl.txt").read.
    # remove "cache_key" from the request,
    # try to avoid getting cached results
    gsub(/&cache_key=.*\'/, "\'").
    gsub("--compressed", "--compressed --silent") # make curl silent

  if test
    result = AVAILABLE_SAMPLE
  else
    result = JSON.parse(`#{curl}`)
  end

  if result["container"]["modules"].first["id"].include?("errors_no_availability")
    puts "No availability\n"
  else
    puts "Found a slot! Notifying..."
    TerminalNotifier.notify("Delivery slot available", title: "Slot found", open: "https://www.instacart.com/", sound: "default")
  end
end

options = {
  test: false,
  wait: 60
}

OptionParser.new do |opts|
  opts.banner = "Usage: instacart.rb [options]"

  opts.on("-t", "--test", "run in test mode") do |t|
    options[:test] = t
  end
end.parse!

while true
  check(test: options[:test])
  sleep 60
end
