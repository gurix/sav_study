module I18nHelper
  def translate(key, options = {})
    super(key, options.merge(raise: true))
  rescue I18n::MissingTranslationData
    scope_key_by_partial(key)
  end
  alias t translate
end
