# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# encoding: UTF-8

admin = Admin.create(name: "everytime1004", email: "admin@admin.com", password: "didi1004", password_confirmation: "didi1004")

User.create(name: "junho", email: "junho@junho.com", password: "didi1004", password_confirmation: "didi1004", phone_first: "010", phone_second: "2426", phone_third: "6556")
