## Model for a single Micro Post
class MicroPost extends Backbone.Model

  #  Url where micro posts lives.
  url: '/microposts/all/'

  # Constructor initializes its field from a javascript raw object.
  # Fields:
  #
  # * id : micro post id in database.
  # * author : micro post author.
  # * date : micro post publish date.  
  # * content : micro post content.
  constructor: (microPost) ->
    super

    @set('author', microPost.author)
    @set('authorKey', microPost.authorKey)
    @set('micropostId', microPost._id)
    @set('content', microPost.content)
    @attachments = microPost.attachments
    @id = microPost._id

    content = microPost.content.replace(/<(?:.|\s)*?>/g, "")
    converter = new Showdown.converter()
    html = converter.makeHtml(content)
    @set('contentHtml', html)
    @attributes['contentHtml'] = html

    if microPost.date
      postDate = Date.parseExact(microPost.date, "yyyy-MM-ddTHH:mm:ssZ")
      urlDate = postDate.toString("yyyy-MM-dd-HH-mm-ss/")
      @attributes['urlDate'] = urlDate

    @attributes["isNoteAttached"] = false
    @attributes["isPictureAttached"] = false
    for doc in @attachments
      if doc.doc_type == "Note"
        @attributes["isNoteAttached"] = true
      else
        @attributes["isPictureAttached"] = true


  ### Getters / Setters ###

  getDisplayDate: ->
    @attributes['displayDate']

  setDisplayDate: ->
    dateToSet = @attributes["date"]
    @setDisplayDateFromDbDate(dateToSet)
  
  # Convert raw *date* to human readable date.
  setDisplayDateFromDbDate: (date) ->
    if date
      postDate = Date.parseExact(date, "yyyy-MM-ddTHH:mm:ssZ")
      stringDate = postDate.toString("dd MMM yyyy, HH:mm")
      @attributes['displayDate'] = stringDate
      postDate
    date
  
  getUrlDate: ->
    @attributes['urlDate']

  getAuthor: ->
    @get('author')

  getAuthorKey: ->
    @get('authorKey')

  getDate: ->
    @get('date')

  getContent: ->
    @get('content')

  # Sends a delete request to services backend then ask view to remove micro 
  # post view.
  delete: ->
    @url = "/microposts/" + @id + "/"
    @destroy()
    @view.remove()

  # Micro post is considered as new if no author is set.
  isNew: ->
    !@getAuthor()

  downloadFile: (doc, callbacks) ->
    $.ajax
      type: "POST"
      url: "/microposts/#{@id}/attach/download/"
      contentType: "application/json"
      data: JSON.stringify(doc)
      success: callbacks.success
      error: callbacks.error


## Micro Post collection
class MicroPostCollection extends Backbone.Collection
  model: MicroPost

  # Url where micro posts lives.
  url: '/microposts/all/'

  # Collection sorting is based on post publsh date.
  comparator: (microPost) ->
    microPost.getDate()

  # Select which field from backend response to use for parsing to populate  
  # collection.
  parse: (response) ->
    response.rows


