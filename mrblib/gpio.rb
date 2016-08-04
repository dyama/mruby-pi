
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
      self.open
    end
    def open
      File.open("#{GPIO::PATH}/export", "w") do |f|
        f.write "#{@no}\n"
      end
      File.open("#{GPIO::PATH}/gpio#{@no}/direction") do |f|
        f.write "#{@mode}\n"
      end
    end
    def close
      File.open("#{GPIO::PATH}/unexport", "w") do |f|
        f.write "#{@no}\n"
      end
    end
    def write(s)
      raise if @mode != GPIO::OUT
      File.open("#{GPIO::PATH}/gpio#{@no}/value", "w") do |f|
        f.write s
      end
    end
    def read
      raise if @mode != GPIO::IN
      File.open("#{GPIO::PATH}/gpio#{@no}/value", "r") do |f|
        f.read.chomp
      end
    end
    def on
      self.write "#{GPIO::ON}\n"
    end
    def off
      self.write "#{GPIO::OFF}\n"
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

