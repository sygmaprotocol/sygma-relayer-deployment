resource "local_file" "dns" {
  count    = var.relayers
  content  = aws_lb.main[count.index].dns_name
  filename = "${path.module}/dns/dns.${count.index}"
}

resource "null_resource" "dns" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/dns/"
    command = <<EOF
      rm dns_address
      for i in dns.*; do (cat $i; echo '') >> dns_address; done
      rm dns.*
    EOF
  }
  depends_on = [
    local_file.dns
  ]
}