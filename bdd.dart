import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

StepDefinitionGeneric dadoQueEstouNaTelaDeCadastro() {
  return given<FlutterWorld>(
    'Eu estou na tela de cadastro',
    (context) async {
      // Navegar para a tela de cadastro
      await context.world.appDriver.tap(find.byTooltip('Cadastro'));
      await context.world.appDriver.waitFor(find.byType('TelaCadastro'));
    },
  );
}

StepDefinitionGeneric quandoEuColocarMinhasInformacoes() {
  return when<FlutterWorld>(
    'Eu coloco minhas informações',
    (context) async {
      await context.world.appDriver.enterText(
        find.byValueKey('username_field'),
        'yasmin',
      );
      await context.world.appDriver.enterText(
        find.byValueKey('email_field'),
        'yasminbonilha@gmail.com',
      );
      await context.world.appDriver.enterText(
        find.byValueKey('password_field'),
        'Yasmin12345@',
      );
    },
  );
}

StepDefinitionGeneric euDeveriaReceberUmEmailDeConfirmacao() {
  return then<FlutterWorld>(
    'Eu deveria receber um e-mail de confimação',
    (context) async {
      await context.world.appDriver.waitFor(find.text('Cadastro feito com sucesso'));
    },
  );
}

void main() {
  final steps = [
    dadoQueEstouNaTelaDeCadastro(),
    quandoEuColocarMinhasInformacoes(),
    euDeveriaReceberUmEmailDeConfirmacao()
  ];

  final config = FlutterTestConfiguration()
    ..features = [Glob(r'features/**.feature')]
    ..reporters = [ProgressReporter()]
    ..stepDefinitions = steps
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test_driver/app.dart';

  GherkinRunner().execute(config);
}