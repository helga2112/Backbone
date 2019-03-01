colums = 10
rows = 10

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
        "click": "open"

    open:()->
        console.log this.el
        this.el.style.backgroundColor = 'red'


###
    Add buttons Start and Reset
###
GameButtonModel = Backbone.Model.extend {
     defaults: 
        caption: 'NEW Button',
        className: 'custom-button'

}

GameButtonView = Backbone.View.extend
    tagName: 'button',
    className: 'test1'

    render: ()->
        div = document.createElement('div')
        this.$el.html this.model.get('caption')
        return this

    events:
        'click':'startGameHandler'
        

    startGameHandler:(ev)->
       ttt = $(ev.currentTarget)
       console.log ttt


ButtonsCollection = Backbone.Collection.extend
    model: GameButtonModel

buttonModel = new GameButtonModel()

GameButtonsView = Backbone.View.extend
    tagName: 'li'

    render: ()->
        this.collection.each(this.addToView, this)
        return this

    addToView:(buttonModel)->
        viewButton = new GameButtonView model: buttonModel
        this.$el.append(viewButton.render().el)



# инициализация грида
collection = []
maxCells = colums * rows - 1
for i in [0..maxCells]
    collection.push {}

gridCollection = new GridCollection collection
gridView = new GridView {collection: gridCollection}

# инициализация кнокок Start and Reload
buttons = [{caption:'Start', className:'start'},
            {caption:'Reload', className: 'reload'}]

buttonsCollection = new ButtonsCollection buttons

gameButtonsView = new GameButtonsView {collection: buttonsCollection}
console.log buttonsCollection   

$(document.body).append(gameButtonsView.render().el);
$(document.body).append(gridView.render().el);
