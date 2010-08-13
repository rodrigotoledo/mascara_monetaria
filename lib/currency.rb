# Me recordo que peguei essas funcoes em algum lugar mas nao me recordo aonde
# quem for o dono me avise
module Currency
  BRL = {:delimiter => ".", :separator => ",", :unit => "R$ ", :precision => 2, :position => "before"}
  USD = {:delimiter => ',', :separator => ".", :unit => "$ ", :precision => 2, :position => "before"}
  DEFAULT = BRL.merge(:unit => "R$ ")

  module String
    def to_number(options={})
      return self.gsub(/./,'').gsub(/,/,'.').to_f
    end

    def numeric?
      self =~ /^(\+|-)?[0-9]+((\.|,)[0-9]+)?$/ ? true : false
    end
  end

  module Number
    def number_with_precision(options = {})
      number = self
      default   = Currency::DEFAULT.stringify_keys
      options   = default.merge(options.stringify_keys)
      precision = options[:precision] || default[:precision]


      return (number * (10**precision)).round / (10**precision).to_f
    end

    def to_currency(options = {})
      number = self
      default   = Currency::DEFAULT
      options   = default.merge(options)
      precision = options[:precision] || default[:precision]
      unit      = options[:unit] || default[:unit]
      position  = options[:position] || default[:position]
      separator = precision > 0 ? options[:separator] || default[:separator] : ""
      delimiter = options[:delimiter] || default[:delimiter]

      begin
        parts = number.with_precision(precision).split('.')
        number = unit + parts[0].to_i.with_delimiter(delimiter) + separator + parts[1].to_s
        number
      rescue
        number
      end
    end

    def with_delimiter(delimiter=",", separator=".")
      number = self
      begin
        parts = number.to_s.split(separator)
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
        parts.join separator
      rescue
        self
      end
    end

    def with_precision(precision=2)
      number = self
      "%01.#{precision}f" % number
    end
  end
end

class Fixnum; include Currency::Number; end
class Bignum; include Currency::Number; end
class BigDecimal; include Currency::Number; end
class Float; include Currency::Number; end
class String; include Currency::String; end
class NilClass; include Currency::String; end

