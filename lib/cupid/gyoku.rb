# ExactTarget follows camelcase convention for soap objects

Gyoku.convert_symbols_to do |key|
  key.camelcase.gsub /Id(?![a-z])/, "ID"
end
