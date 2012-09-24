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
	
	test "criar as transações" do
		caixa = Caixa.first
		assert_difference("Transacao.count", +3) do
			xhr(:post, :cria_varias_transacoes, criar: { caixa_id: caixa.id, transacoes: {
				'0' => { importar: 'true',  data: '01/05/2012', descricao: '1', valor: '100.00'},
				'1' => { importar: 'true',  data: '01/05/2012', descricao: '2', valor: '-100.00'},
				'2' => { importar: 'true',  data: '01/05/2012', descricao: '3', valor: '1300.00'},
				'3' => { importar: 'false', data: '01/05/2012', descricao: '4', valor: '100.00'},
				'4' => { importar: 'false', data: '01/05/2012', descricao: '5', valor: '100.00'}
			}})
			
			trns = assigns(:transacoes_criadas)
			assert_equal(3, trns.size)
			trns.each do |t|
				assert_equal(true, t.realizada, 'as transacoes devem ser realizadas')
				assert_equal(caixa, t.caixa)
				assert_equal(Date.new(2012,5,1), t.data, 'data')
				assert(t.valor.in?([100, -100.00, 1300.00]), 'valor nao deu certo')
				assert(t.descricao.in?(['1', '2', '3']), 'descricao nao deu certo')
			end
		end
	end
end