class OrderEvent < BaseEvent
  def created
    puts "create pipedrive deal"
    puts "send slack notification"
  end
end
