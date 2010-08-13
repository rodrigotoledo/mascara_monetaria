# encoding: utf-8
require File.join(File.dirname(__FILE__),"..","test_helper")


class Salario
  include MascaraMonetaria
  attr_accessor :valor, :valor_de_ferias
  usar_com_moeda [:valor,:valor_de_ferias]
end

class SalarioTest < Test::Unit::TestCase
  def test_have_salario_class
    assert Salario.new, 'Não existe a classe Salario'
  end
  
  
  def test_type_fields
    salario = Salario.new
    salario.valor = 1000
    salario.valor_de_ferias = 1000.50
    assert salario.valor.is_a?(Integer),"Não é um inteiro"
    assert salario.valor_de_ferias.is_a?(Float),"Não é um ponto flutuante"
  end
  
  def test_have_3_methods_to_attributes
    salario = Salario.new
    assert salario.public_methods.include?("valor_mask"), "Não tem valor_mask"
    assert salario.public_methods.include?("valor_mask="), "Não tem valor_mask="
    assert salario.public_methods.include?("valor_f"), "Não tem valor_f"
    
    assert salario.public_methods.include?("valor_de_ferias_mask"), "Não tem valor_de_ferias_mask"
    assert salario.public_methods.include?("valor_de_ferias_mask="), "Não tem valor_de_ferias_mask="
    assert salario.public_methods.include?("valor_de_ferias_f"), "Não tem valor_de_ferias_f"
  end
  
  def test_with_mask_and_float
    salario = Salario.new
    salario.valor = 123.56
    salario.valor_de_ferias = 1765.98
    assert_equal salario.valor_mask,"R$ 123,56", "Não tem valor_mask"
    assert_equal salario.valor_de_ferias_mask,"R$ 1.765,98", "Não tem valor_de_ferias_mask"
    
    salario.valor = 12356
    assert_equal salario.valor_mask,"R$ 123,56", "Não tem valor_mask para um valor inteiro"
    assert_equal salario.valor_mask(:unit => "$"),"$123,56", "Não tem valor_mask atribuindo unidade"
  end
end