#!/bin/bash

# disabling current version in nodejs  and enabling node version20.

dnf module disable nodejs -y 
dnf module enable nodejs:20 -y
dnf install nodejs -y
