GPIO.open(17, GPIO::OUT) do |pin|
  p pin.no
  p pin.mode
  pin.on
  sleep 1
  pin.off
end

pin = GPIO.open(23, GPIO::IN)
p pin.read
pin.close

