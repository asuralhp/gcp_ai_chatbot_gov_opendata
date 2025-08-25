module "gcloudfunc-chatbot-test" {
    source = "./gcloudfunc"
    name = "chatbot"
    project = var.project
    region = var.region
}


module "gcloudfunc-chatbot-map" {
    source = "./gcloudfunc"
    name = "chatbot-map"
    project = var.project
    region = var.region
}


module "gcloudfunc-chatbot-image" {
    source = "./gcloudfunc"
    name = "chatbot-image"
    project = var.project
    region = var.region
}



