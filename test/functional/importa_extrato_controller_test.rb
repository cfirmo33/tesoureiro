# encoding: UTF-8

require 'test_helper'

class ImportaExtratoControllerTest < ActionController::TestCase
	
	test "deve ter o index" do
		get(:index)
		assert_response(:success)
	end
	
	test "deve carregar as transações" do
		
		arquivo = fixture_file_upload('extratos/bb.csv')

		#acho que temos um bug em fixture_file_upload
		#veja: 'https://github.com/rails/rails/issues/799'
		def arquivo.tempfile
			self
		end
		
		post(:escolhe_transacoes, importar: {
			banco: 'BB',
			formato: 'csv',
			arquivo: arquivo
		})
		
		assert_not_nil(assigns(:extrato), '@extrato')
		extrato = assigns(:extrato)
		assert(extrato.transacoes.any?, "deveria ter carregado algumas transações")
		assert_equal(27, extrato.transacoes.size, 'deveria ter 27 transacoes')
		
		extrato.transacoes.each do |trn|
			assert_not_nil(trn.descricao, 'descricao')
		end
	end
end