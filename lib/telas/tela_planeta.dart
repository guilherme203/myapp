import 'package:flutter/material.dart';
import '../controles/controle_planeta.dart';
import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _nomeController.text = _planeta.tamanho.toString();
    _nomeController.text = _planeta.distancia.toString();
    _nomeController.text = _planeta.apelido!;
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dados do planeta foram ${widget.isIncluir ? 'incluindo' : 'altrado'} com sucesso!\n'),
        ),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty || valor.length < 3) {
                      return 'Por favor, insira o nome do planeta (3 ou mais caracteres)';
                    }
                    return null;
                  },
                  onSaved: (valor) {
                    _planeta.nome = valor!;
                  },
                ),
                TextFormField(
                  controller: _tamanhoController,
                  decoration: const InputDecoration(
                    labelText: 'Tamanho (em km)',
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor, informe o tamanho do planeta';
                    }
                    if (double.tryParse(valor) == null) {
                      return 'Insira um número válido para o tamanho';
                    }
                    return null;
                  },
                  onSaved: (valor) {
                    _planeta.tamanho = double.parse(valor!);
                  },
                ),
                TextFormField(
                    controller: _distanciaController,
                    decoration: const InputDecoration(
                      labelText: 'Distância (em km)',
                    ),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor, informe a distância do planeta';
                      }
                      if (double.tryParse(valor) == null) {
                        return 'Insira um nome válido para a distância';
                      }
                      return null;
                    },
                    onSaved: (valor) {
                      _planeta.distancia = double.parse(valor!);
                    }),
                TextFormField(
                  controller: _apelidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apelido',
                  ),
                  onSaved: (valor) {
                    _planeta.apelido = valor;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Salvar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
