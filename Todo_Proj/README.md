# README

## This was my first experience building an app in Django. I followed a tutorial from youtuber "techwithtim."

### See "Feature Pictures" folder to see some of the integrated views the code renders.

### Below are some key features of the site:
* User login/logout and registration system.   
* User-specific page access
* Ability to create and edit todo lists
* Sidebar navigation
* Crispy forms formatting of generic and custom forms

### Funny story:

I went through the tutorial twice. On the first try, I quit at the end because I was getting an error 
when trying to create a new todo list. It was saying the list was referenced before creation. I couldn't figure it out.

I restart. By the time I get to the end, I had started and completed my 
blog project. Again, at the end, I go to create a new list and get the same error. 
I quickly figure out it's because the form has a checkbox BooleanField which I did not
change the default value to <i>"required=False."</i>

I laugh and immediately text my girlfriend about it since she saw the frustration I had the first time. 
I'm just happy I was able to debug that  oversight rather quickly, instead of hitting a complete wall like my first go-around :)
