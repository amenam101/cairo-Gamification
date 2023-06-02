#[contract]

mod Gamification {

    use starknet::get_caller_address;
    use starknet::ContractAddress;


    struct Storage {

        // Address del ganador del premio
        winnerAddress: ContractAddress,

        // Puntuación más alta del juego
        highestScore: u16,

        // Identifica la puntuación más alta de determinada address
        highScores: LegacyMap::<ContractAddress, u16>,

    }

    /// El jugador registra su highscore
    #[external]
    fn submitScore(score: u16)  {
        // Check del highscore del jugador
        let caller = get_caller_address();
        let highScoreGame = highScores::read(caller);
        if score > highScoreGame {
            highScores::write(caller, score);
        }

        let highestScore = highScores::read(caller);
        // Check del highscore del juego
        if score > highestScore {
            winnerAddress::write(caller);
            highestScore::write(score);
        }
    }

    #[view]
    fn highestScoreGames() -> u16 {
        highestScore::read()
    }

    #[view]
    fn highScorePlayer() -> u16 {
        highScores::read(get_caller_address())
    }

}