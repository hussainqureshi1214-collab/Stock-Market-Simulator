# Pakistan Stock Market Simulator

**Developed by Hussain Raza Qureshi**

A JavaFX desktop application simulating the Pakistan Stock Exchange (PSX) with real-time price simulation, portfolio management, candlestick charts, and AI-powered stock predictions.

---

## Prerequisites

- **Java JDK 21+** — [Download](https://jdk.java.net/)
- **JavaFX SDK 26** — Located at `A:\openjfx-26_windows-x64_bin-sdk\javafx-sdk-26`
- **MySQL Server 8.0+** — Running on `localhost:3306` with user `root` and password `Hussain121472`
- **MySQL Connector/J 8.3.0** — Included in `lib/` folder

## Database Setup

1. Open **MySQL Workbench**
2. Run `sql/psms_complete_database.sql` to create the `psms_db` database with all tables and 150 users of dummy data
3. Alternatively, the app auto-initializes tables on startup via `DatabaseInitializer.java`

## Compile & Run

```batch
compile.bat    REM Compiles all .java files to out/
run.bat        REM Launches the application
```

## Project Structure

```
PakistanStockMarketSimulator/
├── src/com/psms/           # Java source files
│   ├── Main.java           # JavaFX Application entry point
│   ├── Launcher.java       # Non-Application launcher (classpath fix)
│   ├── chart/              # Candlestick chart rendering
│   ├── database/           # JDBC connection & DB initializer
│   ├── manager/            # Business logic managers
│   ├── model/              # Data models (Stock, Portfolio, etc.)
│   └── view/               # JavaFX UI views
├── sql/                    # Database SQL scripts
│   ├── psms_database.sql   # Schema (12 tables, 3NF)
│   ├── psms_dummy_data.sql # 150 users with Pakistani credentials
│   └── psms_complete_database.sql  # Combined schema + data
├── lib/                    # External JARs
│   └── mysql-connector-j-8.3.0.jar
├── compile.bat             # Compilation script
├── run.bat                 # Run script
└── README.md
```

## Features

- User registration & login
- Real-time stock price simulation
- Buy/Sell stock trading
- Portfolio management with balance tracking
- Candlestick chart visualization
- Watchlist management
- AI stock prediction engine
- Wallet (deposit/withdraw)
- Live chat
- Customer support tickets
- App reviews & ratings
- Price alerts
