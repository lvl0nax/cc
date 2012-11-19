window.ClientSideValidations.validators.local['vk'] = function(element, options) {
  if (!element.val()) return;
  if (!/http:\/\/vk\.com\/.*/i.test(element.val())) {
    return options.message;
  }
}

window.ClientSideValidations.validators.local['twitter'] = function(element, options) {
  if (!element.val()) return;
  if (!/http:\/\/(www)?\.twitter\.com\/.*/i.test(element.val())) {
    return options.message;
  }
}

window.ClientSideValidations.validators.local['afisha'] = function(element, options) {
  if (!element.val()) return;
  if (!/http:\/\/(www)?\.afisha\.ru\/.*/i.test(element.val())) {
    return options.message;
  }
}

  // validates_format_of :vk, :with => /http:\/\/vk\.com\/.*/, :message => "Неверный адрес",:allow_blank => true
  // validates_format_of :twitter, :with => /http:\/\/(www)?\.twitter\.com\/.*/, :message => "Неверный адрес", :allow_blank => true
  // validates_format_of :afisha, :with => /http:\/\/(www)?\.afisha\.ru\/.*/, :message => "Неверный адрес", :allow_blank => true
  // validates_format_of :fb, :with => /http:\/\/(www)?\.facebook\.com\/.*/, :message => "Неверный адрес", :allow_blank => true
  // validates_format_of :timepad, :with => /http:\/\/(.*?)\.timepad\.ru\/.*/, :message => "Неверный адрес", :allow_blank => true
  // validates_format_of :lookatme, :with => /http:\/\/(.*?)\.lookatme\.ru\/.*/, :message => "Неверный адрес", :allow_blank => true
