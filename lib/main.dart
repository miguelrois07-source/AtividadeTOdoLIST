import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do MinimaList',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Color(0xFF7B61FF),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
      ),

      home: const TarefaScreen(),
    );
  }
}

class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({required this.id, required this.titulo, this.concluida = false});
}

class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreen();
}

class _TarefaScreen extends State<TarefaScreen> {
  final List<Tarefa> _tarefas = [
    Tarefa(id: '1', titulo: 'Comprar pão, leite e ovo'),
    Tarefa(id: '2', titulo: 'Responder e-mails do trabalho', concluida: true),
    Tarefa(id: '3', titulo: 'Acadêmia as 18h'),
  ];

  final TextEditingController _controller = TextEditingController();

  void _abrirBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'O que precisa ser feito?',
                  filled: true,
                  fillColor: Color(0xFFF3F0FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF7B61FF),
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _adicionarTarefa(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _adicionarTarefa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adicionarTarefa() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();
    Navigator.pop(context);
  }

  void _alternarStatus(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere((t) => t.id == id);
      tarefa.concluida = !tarefa.concluida;
    });
  }

  void _deletarTarefa(String id) {
    final index = _tarefas.indexWhere((t) => t.id == id);
    setState(() => _tarefas.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),

      appBar: AppBar(
        title: const Text('2Do MinimaList'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_tarefas.where((t) => !t.concluida).length} pendentes',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 80),
        itemCount: _tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = _tarefas[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deletarTarefa(tarefa.id),
            child: Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Checkbox(
                  value: tarefa.concluida,
                  activeColor: const Color(0xFF7B61FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (_) => _alternarStatus(tarefa.id),
                ),
                title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: tarefa.concluida
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: tarefa.concluida
                        ? Colors.grey
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                subtitle: Text(
                  tarefa.concluida ? 'Concluida' : 'Pendente',
                  style: TextStyle(
                    fontSize: 12,
                    color: tarefa.concluida
                        ? const Color(0xFF7B61FF)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirBottomSheet,
        backgroundColor: const Color(0xFF7B61FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}