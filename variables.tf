variable "servers" {
    type = list(string)
    default =["jenkins","jenkins-agent"]
}

variable "common_tags" {

}

variable "server_tags" {

}

variable "sg-id"{
    default ="sg-077917637fc069d1f"
}

variable "zone-name" {
    default = "devgani.online"
}