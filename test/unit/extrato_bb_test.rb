# encoding: UTF-8

require 'test_helper'

class ExtratoBbTeste < ActiveSupport::TestCase
	
	setup do
		@file = File.open(Rails.root.join('test/fixtures/extratos/bb.csv'), encoding: "ISO8859-1")
	end
	
	test "quantidade de transações" do
		@imp = Extrato::BB.new(@file)
		assert_equal(27, @imp.transacoes.size, 'o arquivo tem 27 transacoes')
	end
	
	test "conteudo das transacoes" do
		@imp = Extrato::BB.new(@file)
		@imp.transacoes.each do |t|
			assert_not_nil(t.data)
			assert_not_nil(t.descricao)
			assert((t.descricao.size > 2), "a descricao deve ter conteudo")
			assert_not_nil(t.valor)
			assert_nil(t.caixa)
		end
	end
	
	test "não cria novas transacoes, só carrega elas" do
		assert_difference("Transacao.count", 0) do
		  Extrato::BB.new(@file)
		end
	end	
	
	test "o bb deve estar nos bancos e nos formatos suportados" do
		assert(Extrato::BANCOS_E_FORMATOS.has_key?('BB'), "o banco do brasil deveria estar nos bancos suportados")
		assert('csv'.in?(Extrato::BANCOS_E_FORMATOS['BB']), "o bb deveria permitir importar arquivos .csv")
	end
end