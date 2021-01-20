resource "aws_cloudwatch_event_bus" "ntambiye_bus" {
    name = "ntambiye_bus" 
}

###################### Permission for my account ###############
resource "aws_cloudwatch_event_permission" "MyAccountAccess" {
  principal    = "*"
  statement_id = "MyAccountAccess"
}

###################### Creating a rule ##########################
resource "aws_cloudwatch_event_rule" "my_custom_event_rule" {
  name        = "my_custom_event_rule"
  description = "This is a custom event rule that allows events from lambda with detail-type : 'New Order'"
  event_bus_name = aws_cloudwatch_event_bus.ntambiye_bus.name  # à n'est pas oublier sinon, la rule va se caler sur le default bus
  
  event_pattern = <<EOF
     {
       "detail-type": [
         "New Order"
       ]
     } 
     EOF
}

################### Creating CloudWatch log for my event ############
resource "aws_cloudwatch_log_group" "event_brige_ntambiye_bus" {
  name = "event_brige_ntambiye_bus"

  tags = {
    Environment = "latest"
    Application = "TEST"
  }
}

################# Creating target : the cloudwatch ##################
resource "aws_cloudwatch_event_target" "CloudWatch_target" {                                                                
  rule      = aws_cloudwatch_event_rule.my_custom_event_rule.name
  arn       = aws_cloudwatch_log_group.event_brige_ntambiye_bus.arn
  event_bus_name = aws_cloudwatch_event_bus.ntambiye_bus.name  # Si la rule attacher précise l'event_bus_nam, il faut le spécifier ici aussi. sinon la target ne se cree pas. 
                                                               # terrafom apply va échouer
}


