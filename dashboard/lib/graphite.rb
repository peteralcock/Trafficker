require "rest-client"
require "json"
require "date"

class Graphite
  # Pass in the url of graphite server
  def initialize(url="http://stats:3030")
    @url = url
  end

  def get_value(datapoint)
    value = datapoint[0] || 0
    return value.round(2)
  end


  def query(name, since=nil)
    since ||= '-2min'
    url = "#{@url}/render?format=json&target=#{name}&from=#{since}"
    response = RestClient.get url
    result = JSON.parse(response.body, :symbolize_names => true)
    return result.first
  end


  def points(name, since=nil)
    stats = query name, since
    datapoints = stats[:datapoints]

    points = []
    count = 1

    (datapoints.select { |el| not el[0].nil? }).each do|item|
      points << { x: count, y: get_value(item)}
      count += 1
    end

    return points
  end


  def value(name, since=nil)
    stats = query name, since
    last = (stats[:datapoints].select { |el| not el[0].nil? }).last

    return get_value(last)
  end
end