from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from .models import ToDoList, Item
from .forms import CreateNewList

# Create your views here.


def index(request, id):
    ls = ToDoList.objects.get(id=id)  # id of fn arg = id of TDL id number

    if ls in request.user.todolist.all(): # only allow user

    # ex. form output: {"save":["save"], "c1":["clicked"]}
        if request.method == "POST":
            print(request.POST)

            if request.POST.get("save"):  # save button logic - str gets the key's value
                for item in ls.item_set.all():
                    if request.POST.get("c" + str(item.id)) == "clicked":
                        item.complete = True
                        # updates the item status in the DB "{c#: ["clicked"]}"
                    else:
                        item.complete = False

                    item.save()

            elif request.POST.get("newItem"):
                txt = request.POST.get("new")  # gets text from input textbox (name="new")
                # manually check validity since custom form
                if len(txt) > 2:
                    ls.item_set.create(text=txt, complete=False)
                else:
                    print("invalid input")

        return render(request, "main/list.html", {"ls": ls})
    return render(request, "main/view.html", {})


def home(response):
    return render(response, "main/home.html", {})


def create(request):
    if request.method == "POST":
        form = CreateNewList(request.POST)
        # instantiate form and populate with inputted data -- "binding the form"
        # .POST attr contains the data itself as a dict

        if form.is_valid():  # checks defined fields for valid form input
            n = form.cleaned_data["name"]
            # .cleaned_data outputs a dict, we're selecting the name variable from the form defintion
            t = ToDoList(name=n)
            t.save()
            request.user.todolist.add(t)

        return HttpResponseRedirect("/%i" % t.id)
        # http placeholders to direct to new list page upon successful list creation

    else:  # this runs initially!!! GET request!!! not POST!!!
        form = CreateNewList()  # creates blank form to get passed to HTML
    return render(request, "main/create.html", {"form": form})


def view(request):
    return render(request, "main/view.html", {})
