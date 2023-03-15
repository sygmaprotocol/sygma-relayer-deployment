output "lb_dns_0" {
  value = aws_lb.main[0].dns_name
}

// output "lb_dns_1" {
  // value = aws_lb.main[1].dns_name
// }

// output "lb_dns_2" {
  // value = aws_lb.main[2].dns_name
// }