<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class ProcessItemsCommand extends Command
{
    protected $signature = 'process-items';
    
    protected $description = 'Process all pending items';

    public function handle(): void
    {
        $this->comment('Starting to process items...');
        
        $items = $this->getItems();
        
        $items->each(function ($item) {
            $this->info("Processing item `{$item->id}`...");
            $this->processItem($item);
        });
        
        $this->comment("Processed {$items->count()} items.");
    }
    
    protected function processItem($item): void
    {
        //
    }
}