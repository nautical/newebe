
# Utility methods for models
module.exports = class Model extends Backbone.Model

    # Model-view binding for forms. It binds an attribute of the model to a
    # field.
    bindField: (attribute, field) ->
        if not field?
            console.log "try to bind a non existing field with #{attribute}"
        else
            field.keyup =>
                @set attribute, field.val(), silent: true
                true

            @on "change:#{attribute}", =>
                field.val @get "attribute"