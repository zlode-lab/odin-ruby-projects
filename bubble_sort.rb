def bubble_sort(arr) 
count = 0
  while count != arr.length - 1
    count = 0
    i = 0
    while i < arr.length - 1
      if arr[i] > arr[i+1]
        placeholder = arr[i+1]
        arr[i+1] = arr[i]
        arr[i] = placeholder
      else
        count += 1
      end
      i += 1
    end
  end
arr
end  
p bubble_sort([4,3,78,2,0,2])