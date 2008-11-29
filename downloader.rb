#
# The MIT License
# 
# Copyright (c) 2008 Christian Bryan
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# downloader.rb
# 
# An easy HTTP downloader for Ruby.
#
# Christian Bryan
# christianbryan@gmail.com
# November 27, 2008
#

require 'open-uri'
require 'net/http'

class Downloader
  
  USER_AGENT = "Songbox (http://deepyogurt.org/projects/songbox)"
  CHUNK_SIZE = 100000
  
  attr_accessor :url, :browser, :content_length
  
  def initialize(url)
    @url = URI.parse(url)
    @browser = Net::HTTP.new(@url.host, @url.port)
    @content = ""
  end
  
  def download(start = 0, stop = content_length, length = CHUNK_SIZE, &block)
    start.step(stop, length) do |n|
      data = fetch_chunk(n, n + length)
      if block_given?
        yield data, n, n + length
      end
      @content << data
    end
  end
  
  def content_length
    @content_length ||= @browser.head(@url.path)['content-length'].to_i
  end
  
  def fetch_chunk(start, stop)
    #puts "Getting bytes #{start}-#{stop} of #{content_length}."
    @browser.request_get(@url.path, { "Range" => "bytes=#{start}-#{stop}" }).body
  end
  
end
