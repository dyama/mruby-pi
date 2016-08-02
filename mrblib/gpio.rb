
module GPIO
  OUT  = 'out'
  IN   = 'in'
  ON   = '1'
  OFF  = '0'
  PATH = '/sys/class/gpio'
  class Pin
    attr_reader :no
    attr_reader :mode
    def initialize(no, mode)
      @no = no
      @mode = mode
      File.open("#{GPIO::PATH}/export", "w") do |f|
        f.write "#{@no}\n"
      end
      File.open("#{GPIO::PATH}/gpio#{@no}/direction") do |f|
        f.write "#{@mode}\n"
      end
    end
    def on
      if @mode != GPIO::OUT
        raise "Mode of the pin object is not OUT."
      end
      File.open("#{GPIO::PATH}/gpio#{@no}/value", "w") do |f|
        f.write(GPIO::ON)
      end
    end
    def off
      if @mode != GPIO::OUT
        raise "Mode of the pin object is not OUT."
      end
      File.open("#{GPIO::PATH}/gpio#{@no}/value", "w") do |f|
        f.write(GPIO::OFF)
      end
    end
    def read
      if @mode != GPIO::IN
        raise "Mode of the pin object is not IN."
      end
      File.open("#{GPIO::PATH}/gpio#{@no}/value", "r") do |f|
        f.read.chomp
      end
    end
    def close
      File.open("#{GPIO::PATH}/unexport", "w") do |f|
        f.write "#{@no}\n"
      end
    end
  end
  def GPIO.open(no, mode = GPIO::OUT)
    if block_given?
      begin
        pin = Pin.new(no, mode)
        yield pin
      ensure
        pin.close if pin
      end
    else
      Pin.new(no, mode)
    end
  end
end

GPIO.open(17, GPIO::OUT) do |pin|
  puts pin.no
  puts pin.mode
  pin.on
  sleep 1
  pin.off
end

pin = GPIO.open(23, GPIO::IN)
pin.close

