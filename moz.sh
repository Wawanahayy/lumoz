#!/bin/bash

show_display() {
    curl -s https://raw.githubusercontent.com/Wawanahayy/JawaPride-all.sh/refs/heads/main/display.sh | bash
}

main_menu() {
    show_display
    echo "Silakan pilih operasi:"
    echo "1) Install dan mulai mining"
    echo "2) Uninstall mining"
    echo "3) Lihat log"
    read -p "Masukkan pilihan (1/2/3): " choice

    case $choice in
        1) install_and_start ;;
        2) uninstall ;;
        3) view_logs ;;
        *) echo "Pilihan tidak valid"; main_menu ;;
    esac
}

install_and_start() {
    show_display
    read -p "Masukkan alamat wallet: " wallet_address
    read -p "Masukkan nama miner: " miner_name

    echo "Pilih tipe GPU:"
    echo "1) Nvidia"
    echo "2) AMD"
    read -p "Masukkan pilihan (1/2): " gpu_choice

    if [ "$gpu_choice" -eq 1 ]; then
        wget https://github.com/6block/zkwork_moz_prover/releases/download/v1.0.1/moz_prover-v1.0.1_cuda.tar.gz
        tar -zvxf moz_prover-v1.0.1_cuda.tar.gz
        cd moz_prover || exit
    elif [ "$gpu_choice" -eq 2 ]; then
        wget https://github.com/6block/zkwork_moz_prover/releases/download/v1.0.1/moz_prover-v1.0.1_ocl.tar.gz
        tar -zvxf moz_prover-v1.0.1_ocl.tar.gz
        cd moz_prover || exit
    else
        echo "Pilihan tidak valid, kembali ke menu utama"
        main_menu
        return
    fi

    sed -i "s/^reward_address=.*/reward_address=$wallet_address/" inner_prover.sh
    sed -i "s/^custom_name=.*/custom_name=\"$miner_name\"/" inner_prover.sh

    sudo chmod +x run_prover.sh
    ./run_prover.sh

    echo "Mining telah dimulai"
}

uninstall() {
    show_display
    echo "Sedang menghapus program mining..."
    rm -rf moz_prover moz_prover-v1.0.1_cuda.tar.gz moz_prover-v1.0.1_ocl.tar.gz
    echo "Program mining telah dihapus"
}

view_logs() {
    show_display
    if [ -f "moz_prover/prover.log" ]; then
        tail -f moz_prover/prover.log
    else
        echo "File log tidak ditemukan, silakan install dan mulai mining terlebih dahulu"
    fi
}

main_menu
