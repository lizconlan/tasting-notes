require 'rest-client'
require 'json'
require 'yaml'

class BrewDB
  def initialize
    begin
      @key = ENV['brewdbkey'] || YAML::load(File.read("config/brewdb.yml"))[:api_key]
    rescue
      raise "Unable to contact API - no key provided"
    end
  end
  
  def get_brewery_info(brewery_id)
    begin
      result = RestClient.get("http://www.brewerydb.com/api/breweries?id=#{brewery_id}&format=json&apikey=#{@key}")
    rescue RestClient::ResourceNotFound
      return {}
    end
    data = JSON.parse(result)
    return data["breweries"]["brewery"]
  end
  
  def find_brewery_by_name(name)
    begin
      result = RestClient.get("http://www.brewerydb.com/api/search?q=#{name.gsub(" ", "+")}&type=brewery&format=json&apikey=#{@key}")
    rescue RestClient::ResourceNotFound
      return []
    end
    data = JSON.parse(result)
    return [data["results"]["result"]] if data["results"]["result"].is_a?(Hash)
    return [] if data["results"]["result"].nil?
    if data["results"]["result"][0]["name"] == name
      return [data["results"]["result"][0]]
    else
      return data["results"]["result"][0..4]
    end
  end
  
  def list_beers_by_brewery_id(brewery_id)
    begin
      result = RestClient.get("http://www.brewerydb.com/api/beers?brewery_id=#{brewery_id}&metadata=1&format=json&apikey=#{@key}")
    rescue RestClient::ResourceNotFound
      return []
    end
    data = JSON.parse(result)
    return [] if data["beers"]["beer"].nil?
    return [data["beers"]["beer"]] if data["beers"]["beer"].is_a?(Hash)
    return data["beers"]["beer"]
  end
end