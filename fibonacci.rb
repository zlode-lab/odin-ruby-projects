def fibs(num)
  arr = [0, 1]
  if num < 2 
    return num == 0 ? [0] : arr
  end
  i = 1
  while (i+1 < num) do
    arr.push(arr[i] + arr[i-1])
    i += 1
  end
  arr
end

def fibs_rec(num)
  return num if num < 2
  return fibs_rec(num-1) + fibs_rec(num-2)
end
p fibs(8)
p fibs_rec(8)