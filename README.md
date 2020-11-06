# Monster Shop
Turing School of Software and Design- Module 2 Week 4/5 Group Project

### Contributors
- [Kevin David Cuadros](https://github.com/kevxo)
- [Hanna Davis](https://github.com/Oxalisviolacea)
- [Grant Dempsey](https://github.com/GDemps)
- [Carson Jardine](https://github.com/carson-jardine)

### Overview
This project sets up an ecommerce site. [You can check it out here!](https://agile-temple-04253.herokuapp.com/)

### Design
<img src="https://github.com/Oxalisviolacea/futbol/blob/main/images/flow_chart.png" width="350" height="350">

### Process
Monster Shop was a collaborative project that was accomplished through a combination of remote pairing and independent work. We used an agile workflow with a github project board. 

The project came with a project spec, database, working rails app courtesy of Turing School of Software and Design. We worked together to add tables and functionality that restrict access to certain users. A logged in user can add items to their cart and checkout, as well as update their profile information. A merchant can add new items, enable/disable items, and fulfill orders. An admin can add and edit merchants, and package orders. We were able to build all of the functionality outlined in the spec and in future iterations we would like styling and attempt some extensions.

### Test Coverage
- simplecov: 99.84%
- rspec: 100%

### Installation Instructions
- Fork this repo
- Clone your fork
- From the command line run: 
    - `gem install brcypt`
    - `gem orderly gems`
    - `bundle`
    - `rails db:create`
    - `rails db:migrate`
    - `rails db:seed`
    - run the tests with `bundle exec rspec` (All 197 should be passing)
    - you can also access the site using your rails server, by running `rails s` and visiting localhost:3000

### References
- [project spec](https://github.com/turingschool-examples/monster_shop_2005/blob/main/README.md)
- [original respository](https://github.com/turingschool-examples/monster_shop_2005)
- [heroku app](https://agile-temple-04253.herokuapp.com/)

