#!/bin/bash

# simple-interest.sh
# Bash script to calculate simple interest

# Function to display usage
show_usage() {
    echo "========================================="
    echo "Simple Interest Calculator"
    echo "========================================="
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --principal    Principal amount (required)"
    echo "  -r, --rate         Annual interest rate (in percent, required)"
    echo "  -t, --time         Time period (in years, required)"
    echo "  -h, --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --principal 1000 --rate 5 --time 3"
    echo "  $0 -p 5000 -r 7.5 -t 2.5"
    echo ""
    echo "Interactive mode: Just run $0 without arguments"
    echo "========================================="
}

# Function for interactive input mode
interactive_mode() {
    echo "========================================="
    echo "Simple Interest Calculator - Interactive Mode"
    echo "========================================="
    
    # Get principal amount
    while true; do
        read -p "Enter Principal amount (in your currency): " principal
        # Check if input is a positive number
        if [[ $principal =~ ^[0-9]+(\.[0-9]+)?$ ]] && (( $(echo "$principal > 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid positive number."
        fi
    done
    
    # Get interest rate
    while true; do
        read -p "Enter Annual Interest Rate (in %): " rate
        # Check if input is a positive number
        if [[ $rate =~ ^[0-9]+(\.[0-9]+)?$ ]] && (( $(echo "$rate >= 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid non-negative number."
        fi
    done
    
    # Get time period
    while true; do
        read -p "Enter Time Period (in years): " time
        # Check if input is a positive number
        if [[ $time =~ ^[0-9]+(\.[0-9]+)?$ ]] && (( $(echo "$time > 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid positive number."
        fi
    done
}

# Function to calculate and display results
calculate_interest() {
    echo ""
    echo "========================================="
    echo "CALCULATION RESULTS"
    echo "========================================="
    
    # Calculate simple interest: I = P * R * T / 100
    interest=$(echo "scale=2; $principal * $rate * $time / 100" | bc -l)
    
    # Calculate total amount: A = P + I
    total=$(echo "scale=2; $principal + $interest" | bc -l)
    
    # Display inputs
    printf "%-30s: %'.2f\n" "Principal Amount" $principal
    printf "%-30s: %.2f%%\n" "Annual Interest Rate" $rate
    printf "%-30s: %.2f years\n" "Time Period" $time
    echo "-----------------------------------------"
    
    # Display results
    printf "%-30s: %'.2f\n" "Simple Interest" $interest
    echo "-----------------------------------------"
    printf "%-30s: %'.2f\n" "Total Amount (Principal + Interest)" $total
    echo "========================================="
    
    # Monthly breakdown (optional)
    monthly_interest=$(echo "scale=2; $interest / ($time * 12)" | bc -l)
    printf "%-30s: %'.2f\n" "Average Monthly Interest" $monthly_interest
}

# Function to validate command line arguments
validate_arguments() {
    local errors=0
    
    if [[ -z "$principal" ]]; then
        echo "Error: Principal amount is required."
        errors=$((errors + 1))
    elif ! [[ $principal =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$principal <= 0" | bc -l) )); then
        echo "Error: Principal must be a positive number."
        errors=$((errors + 1))
    fi
    
    if [[ -z "$rate" ]]; then
        echo "Error: Interest rate is required."
        errors=$((errors + 1))
    elif ! [[ $rate =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$rate < 0" | bc -l) )); then
        echo "Error: Interest rate must be a non-negative number."
        errors=$((errors + 1))
    fi
    
    if [[ -z "$time" ]]; then
        echo "Error: Time period is required."
        errors=$((errors + 1))
    elif ! [[ $time =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$time <= 0" | bc -l) )); then
        echo "Error: Time period must be a positive number."
        errors=$((errors + 1))
    fi
    
    return $errors
}

# Main script logic
main() {
    # Check if bc (calculator) is available
    if ! command -v bc &> /dev/null; then
        echo "Error: 'bc' calculator is required but not installed."
        echo "Install it using:"
        echo "  Ubuntu/Debian: sudo apt-get install bc"
        echo "  macOS: brew install bc"
        echo "  Fedora: sudo dnf install bc"
        exit 1
    fi
    
    # Parse command line arguments
    if [[ $# -eq 0 ]]; then
        # No arguments: interactive mode
        interactive_mode
    else
        # Parse command line arguments
        while [[ $# -gt 0 ]]; do
            case $1 in
                -h|--help)
                    show_usage
                    exit 0
                    ;;
                -p|--principal)
                    principal="$2"
                    shift 2
                    ;;
                -r|--rate)
                    rate="$2"
                    shift 2
                    ;;
                -t|--time)
                    time="$2"
                    shift 2
                    ;;
                *)
                    echo "Unknown option: $1"
                    show_usage
                    exit 1
                    ;;
            esac
        done
        
        # Validate command line arguments
        if ! validate_arguments; then
            echo ""
            echo "Please correct the errors above or use interactive mode."
            echo "For help, run: $0 --help"
            exit 1
        fi
    fi
    
    # Calculate and display results
    calculate_interest
    
    # Optional: Ask if user wants to calculate again
    echo ""
    read -p "Would you like to perform another calculation? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        clear
        exec "$0"
    else
        echo "Thank you for using the Simple Interest Calculator!"
    fi
}

# Run the main function with all arguments
main "$@"
