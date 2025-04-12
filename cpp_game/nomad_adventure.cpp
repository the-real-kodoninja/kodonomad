// nomad_adventure.cpp
#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

class Player {
public:
    std::string name;
    int energy;
    int supplies;
    int milesTraveled;

    Player(const std::string& playerName) : name(playerName), energy(100), supplies(50), milesTraveled(0) {}

    void displayStatus() {
        std::cout << "\n--- Status ---\n";
        std::cout << "Name: " << name << "\n";
        std::cout << "Energy: " << energy << "\n";
        std::cout << "Supplies: " << supplies << "\n";
        std::cout << "Miles Traveled: " << milesTraveled << "\n";
    }

    bool isAlive() {
        return energy > 0 && supplies > 0;
    }
};

class Event {
public:
    static void randomEvent(Player& player) {
        int eventType = rand() % 3;
        switch (eventType) {
            case 0: // Find Supplies
                std::cout << "You found a hidden cache of supplies!\n";
                player.supplies += 20;
                player.energy -= 5;
                break;
            case 1: // Encounter Storm
                std::cout << "A storm hits! You lose some supplies and energy.\n";
                player.supplies -= 15;
                player.energy -= 10;
                break;
            case 2: // Meet Another Nomad
                std::cout << "You meet another nomad and trade stories. You feel refreshed.\n";
                player.energy += 10;
                player.supplies -= 5;
                break;
        }
    }
};

int main() {
    srand(static_cast<unsigned int>(time(0))); // Seed random number generator

    std::string playerName;
    std::cout << "Welcome to Nomad Adventure!\n";
    std::cout << "Enter your name: ";
    std::getline(std::cin, playerName);

    Player player(playerName);
    std::cout << "Hello, " << player.name << "! You're a nomad traveling the world.\n";
    std::cout << "Your goal is to travel 1000 miles while managing your energy and supplies.\n";

    while (player.isAlive() && player.milesTraveled < 1000) {
        player.displayStatus();

        std::cout << "\nWhat would you like to do?\n";
        std::cout << "1. Travel (costs 10 energy, 5 supplies)\n";
        std::cout << "2. Rest (gains 20 energy, costs 5 supplies)\n";
        std::cout << "3. Forage (gains 10 supplies, costs 5 energy)\n";
        std::cout << "Enter your choice (1-3): ";

        int choice;
        std::cin >> choice;
        std::cin.ignore(); // Clear the newline character

        switch (choice) {
            case 1: // Travel
                player.milesTraveled += 50;
                player.energy -= 10;
                player.supplies -= 5;
                std::cout << "You traveled 50 miles!\n";
                Event::randomEvent(player);
                break;
            case 2: // Rest
                player.energy += 20;
                player.supplies -= 5;
                std::cout << "You rested and feel refreshed.\n";
                break;
            case 3: // Forage
                player.supplies += 10;
                player.energy -= 5;
                std::cout << "You foraged and found some supplies.\n";
                break;
            default:
                std::cout << "Invalid choice. Try again.\n";
                break;
        }

        // Cap energy and supplies
        if (player.energy > 100) player.energy = 100;
        if (player.supplies > 100) player.supplies = 100;
        if (player.energy < 0) player.energy = 0;
        if (player.supplies < 0) player.supplies = 0;
    }

    player.displayStatus();
    if (player.milesTraveled >= 1000) {
        std::cout << "Congratulations, " << player.name << "! You've traveled 1000 miles and won the game!\n";
    } else {
        std::cout << "Game Over! You ran out of energy or supplies.\n";
    }

    return 0;
}
