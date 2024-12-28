def stock_picker(days)
  potential_best_buy_day = 0
  buy_day = 0
  sell_day = 0
  potential_best_buy_value = 99
  profit = 0
  days.each_with_index{ |value, day|
    if value < potential_best_buy_value
      potential_best_buy_value = value
      potential_best_buy_day = day
    elsif value - potential_best_buy_value > profit
      profit = value - potential_best_buy_value
      sell_day = day
      buy_day = potential_best_buy_day
    end
  }
  return [buy_day, sell_day]
end

stock_picker([17,3,6,9,15,8,6,1,10,0])