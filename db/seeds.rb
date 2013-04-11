# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# encoding: UTF-8

admin = User.create(name: "everytime1004", email: "anyday1004@gmail.com", password: "didi1004", password_confirmation: "didi1004")
admin.update_attribute :admin, true

admin.posts.create!(title: "Danger!!", description: "Danger!!")
