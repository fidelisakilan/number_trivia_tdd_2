import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_tdd_2/features/domain/entities/number_trivia.dart';
import 'package:number_trivia_tdd_2/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_tdd_2/features/presentation/widgets/widgets.dart';
import 'package:number_trivia_tdd_2/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      //top half
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start Searching!',
                    );
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                        numberTrivia: NumberTrivia(
                            text: state.trivia.text,
                            number: state.trivia.number));
                  } else {
                    return LoadingWidget();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              //bottom half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
