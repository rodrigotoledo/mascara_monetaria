require File.join(File.dirname(__FILE__),"currency")
module MascaraMonetaria

  # author:
  #   agc.rodrigo@gmail.com
  #   erick.pereira86@gmail.com
  # company:
  #   jera.com.br
  class << self
    def included base #:nodoc:
      base.extend ClassMethods
    end
  end

  module ClassMethods
    # Utilizacao
    # usar_com_moeda :valor, :valor_faturado, {:valor_fixo => {:unit => "$",""}}
    # Resultado
    # São criados 3 métodos para cada atributo passado:
    # nome_atributo_f, nome_atributo_mask e nome_atributo_mask=
    def usar_com_moeda atributos = []
      atributos = [atributos] unless atributos.is_a?(Array)

      atributos.each do |atributo|
        opcoes = {}
        nome_atributo = atributo

        if atributo.is_a?(Hash)
          opcoes = opcoes.merge(atributo.values.first)
          nome_atributo = atributo.keys.first
        end

        define_method "#{nome_atributo}_f" do
          _f = send(nome_atributo.to_sym)
          _f.is_a?(Integer) ? _f.to_f / 100.0 : _f
        end

        define_method "#{nome_atributo}_mask=" do |novo_valor|
          write_attribute(nome_atributo.to_sym, novo_valor.to_s.gsub(/[^0-9]/,'').to_i) unless novo_valor.nil?
        end

        define_method "#{nome_atributo}_mask" do |*args|
          opcoes_atributo = args[0] || {}
          send("#{nome_atributo}_f".to_sym).to_currency(opcoes.merge(opcoes_atributo))
        end

      end
    end


  end


end

# Set it all up.
if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, MascaraMonetaria)
end

