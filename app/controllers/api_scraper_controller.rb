require 'proxycrawl'
require 'nokogiri'

class ApiScraperController < ApplicationController
  def scraper 
    product = {}
    api = ProxyCrawl::API.new(token: 'Wo0vsth7eC_LnzJzbXOmrQ')
    url = 'https://www.amazon.com/PlayStation-4-Pro-1TB-Console/dp/B01LOP8EZC/'
    html = api.get(url)
    doc = Nokogiri::HTML(html.body)
    product_name = doc.at('#productTitle').text.strip
    product['product_name'] = product_name
    product_description = ''
    doc.css('#feature-bullets li').each do |li|
      unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
        product_description += li.text.strip + ' '
      end
    end
    product['product_description'] = product_description
    product_price = 0
    if doc.at('span#priceblock_ourprice')
      product_price = doc.at('span#priceblock_ourprice').text.strip
    elsif doc.at(".a-size-base.a-color-price")
      product_price = doc.at(".a-size-base.a-color-price").text.strip
    end
    product['product_price'] = product_price
    product_reviews = doc.at_css('span#acrCustomerReviewText').present? ? doc.at_css('span#acrCustomerReviewText').text.strip.split(' ').first.tr(',','') : nil
    product['reviews'] = product_reviews
    images = JSON.parse doc.xpath('//div[@id="imgTagWrapperId"]/img/@data-a-dynamic-image')[0].text
    product_image = images.to_a[0][0]
    product['image'] = product_image
    puts "#{product}"
    save_details(url,product)
  end
  def save_details(url,product)
    if(ApiScraperDetails.exists?(api:url))
      ApiScraperDetails.where(api:url).update_all(details:product)
    else
      ApiScraperDetails.create!(api:url,details:product)
    end
  end
end
