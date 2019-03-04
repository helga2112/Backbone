colums = 10
rows = 10
timer = -1

# одна ячейка на сетке
GridItemModel = Backbone.Model.extend 
     defaults: 
        isFree: true
     
# коллекция элементов для создания сетки
GridCollection = Backbone.Collection.extend {
    model: GridItemModel
}

gridItemModel = new GridItemModel()

# вьюшка сетки
GridView = Backbone.View.extend {
    tagName: 'div',

    className: 'grid-container ',

    initialize: ()->
        this.render

    render: ()->
        for i in [0..maxCells]
            item = new GridItemView {model: gridItemModel}
            this.$el.append(item.render().el)
        return this

    reload:()->
         ttt = document.getElementsByClassName 'cell'
         [].forEach.call ttt, (el)-> el.style.backgroundColor = 'white'
         clearInterval timer
         timer = -1
}


# вьюшка одной ячейки
GridItemView = Backbone.View.extend 
    tagName: 'div',

    className: 'cell'

    template: _.template('%= text %>'),

    # react on change event
    initialize: ()->
        this.listenTo this.model, "change", this.render
        this.render()

    render: ()->
        div = document.createElement('div')
        this.$el.html(this.model.get('text'))
        return this


    # react on user click
    events:
        "click": "selectItem"

    selectItem:()->
        this.el.style.backgroundColor = 'red'



# инициализация грида
collection = []
maxCells = colums * rows - 1
for i in [0..maxCells]
    collection.push {}

gridCollection = new GridCollection collection
gridView = new GridView {collection: gridCollection}

# инициализация кнокок Start and Reload

ModelButtons = Backbone.Model.extend
    defaults: 
        classStart: 'class-start',
        classReload: 'class-reload',
        startGame:'Start Game',
        reloadGame:'Reload Game'


###
    Add buttons Start and Reset
###

ButtonsView = Backbone.View.extend
    tagName: 'ul'
    template: _.template('<button class="<%=classStart%>"><%= startGame%></button><button class="<%=classReload%>"><%= reloadGame%></button>'),

    initialize:()->
        @render()
    
    render:()->
        @$el.html @template @model.toJSON()
        return this

    events:
     'click .class-start':'startGameHandler'
     'click .class-reload':'reloadGameHandler'

    startGameHandler:(ev)->
       startGame()

    
    reloadGameHandler:(ev)->
        gridView.reload()

startGame = -> 
    console.log "test"
    timer = setInterval run, 1000
    return

run = ->
    console.log 'TICK'
    cells = document.getElementsByClassName 'cell'
    max = cells.length - 1
    newLive = []
    newDead = []
    for i in [0 .. max]
        neighbors = []
        if(i - colums - 1 > 0 &&  i - colums - 1 < max)  # upA
                neighbors.push cells[i - colums - 1] 
        if(i - colums > 0 && i - colums < max)          # upB
                neighbors.push cells[i - colums]
        if(i - colums + 1 > 0 && i - colums < max)      # upC
                neighbors.push cells[i - colums + 1] 
        if(i - 1 > 0 && i - 1 < max)                     # nearA
                neighbors.push cells[i - 1] 
        if(i + 1 > 0 && i + 1  < max)                   # nearB
                neighbors.push cells[i + 1] 
        if(i + colums - 1 > 0 && i + colums - 1 < max)  # downA
                neighbors.push cells[i + colums - 1] 
        if(i + colums > 0 && i + colums < max)          # downB
                neighbors.push cells[i + colums] 
        if(i + colums + 1 > 0 && i + colums + 1 < max)  # downC
                neighbors.push cells[i + colums + 1] 
        if neighbors.length is 8
            lifeAroundCounter = 0
            for j in [0 .. 7]
                tempColor = neighbors[j].style.backgroundColor
                if tempColor is 'red'
                    lifeAroundCounter++

            if lifeAroundCounter is 3 or lifeAroundCounter is 2
                newLive.push i
            else if lifeAroundCounter > 3 or lifeAroundCounter < 2
                newDead.push i
        
        maxLive = newLive.length - 1
        maxDead = newDead.length - 1 

        console.log 'LIFE' + newLive
        console.log 'DEAD' + newDead

        if maxLive > 0
            for h in [0..maxLive]
                index = newLive[h]
                console.log 'index ' + index + ' dom obg ' + cells[index]
                cells[index].style.backgroundColor = 'red'

        if maxDead > 0    
            for u in [0..maxDead]
                index = newDead[u]
                #console.log 'index' + index + ' dom obg ' + cells[index]
                cells[index].style.backgroundColor = 'white'

      


                
                

            

buttonsModel = new ModelButtons()
buttonsView = new ButtonsView {model: buttonsModel}

$(document.body).append(buttonsView.render().el);

$(document.body).append(gridView.render().el);
