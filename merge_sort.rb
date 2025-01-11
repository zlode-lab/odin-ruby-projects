def merge_sort(arr)
  if (arr.length > 1)
    middle = arr.length / 2
    first_half = merge_sort(arr[0...middle])
    second_half = merge_sort(arr[middle..-1])
    x = 0
    y = 0
    i = 0
    while (i != arr.length) 
      if (first_half[x].nil?)
        arr[i] = second_half[y]
        y += 1
      elsif (second_half[y].nil?)
        arr[i] = first_half[x]
        x += 1
      elsif (first_half[x] > second_half[y])
        arr[i] = second_half[y]
        y += 1
      else
        arr[i] = first_half[x]
        x += 1
      end
      i += 1
    end
  end
  arr
end
p merge_sort([3, 2, 1, 13, 8, 5, 0, 1])
p merge_sort([105, 79, 100, 110])