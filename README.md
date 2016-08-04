# About mruby-pi

Minimum library for using GPIO on Raspberry Pi without WiringPi.
mruby-pi written by 100% mruby script base, includes no C code.

# Dependencies

* iij/mruby-io

# Example

    GPIO.open(17, GPIO::OUT) do |pin|
      p pin.no   # => 17
      p pin.mode # => "out"
      pin.on
      sleep 1
      pin.off
    end

    pin = GPIO.open(23, GPIO::IN)
    p pin.read   # => "1"
    pin.close

# Lisence

* MIT Lisence

# See also

* https://github.com/akiray03/mruby-WiringPi
* https://github.com/WiringPi/WiringPi-Ruby
