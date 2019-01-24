package mymath

func Fabnacci(num int) int {
  if num == 0 || num == 1 {
    return num
  }
  return Fabnacci(num -1) + Fabnacci(num -2)
}
