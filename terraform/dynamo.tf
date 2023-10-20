module "dynamo" {
  source   = "./modules/dynamodb"
  for_each = local.databases

  name           = each.key
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
  billing_mode   = each.value.billing_mode
  attributes     = each.value.attributes
  hash_key       = each.value.hash_key
  range_key      = each.value.range_key
  tags           = { name = each.key }

}