<?php
/**
 * Standalone MediaWiki Parser
 * 
 * This script provides a standalone interface to MediaWiki's parser
 * Usage: php mediawiki_parser.php --wikitext="'''bold''' text" [--format=html|json]
 */

// Set up autoloading for MediaWiki classes
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../lib/includes/AutoLoader.php';

use MediaWiki\MediaWikiServices;
use MediaWiki\Parser\Parser;
use MediaWiki\Parser\ParserOptions;
use MediaWiki\Parser\ParserOutput;
use MediaWiki\Title\Title;
use MediaWiki\User\User;

class StandaloneParser {
    private $services;
    private $parser;
    private $parserOptions;
    
    public function __construct() {
        // Initialize MediaWiki's service container
        $this->services = MediaWikiServices::getInstance();
        
        // Initialize parser
        $this->parser = $this->services->getParser();
        
        // Create default user and title context
        $user = new User();
        $title = Title::newFromText('Standalone_Parser_Page');
        
        // Initialize parser options
        $this->parserOptions = ParserOptions::newFromUser($user);
        $this->parserOptions->setTidy(true);
        $this->parserOptions->setRemoveComments(true);
    }
    
    /**
     * Parse wikitext to HTML
     */
    public function parse($wikitext) {
        // Create a title object for context
        $title = Title::newFromText('Standalone_Parser_Page');
        
        // Parse the text
        $output = $this->parser->parse(
            $wikitext,
            $title,
            $this->parserOptions
        );
        
        return $output->getText();
    }
    
    /**
     * Parse wikitext and return full parsing results
     */
    public function parseWithMetadata($wikitext) {
        $title = Title::newFromText('Standalone_Parser_Page');
        $output = $this->parser->parse(
            $wikitext,
            $title,
            $this->parserOptions
        );
        
        return [
            'text' => $output->getText(),
            'links' => $output->getLinks(),
            'images' => $output->getImages(),
            'categories' => $output->getCategories(),
            'templates' => $output->getTemplates(),
            'sections' => $output->getSections(),
            'properties' => $output->getProperties(),
        ];
    }
}

// CLI interface
if (PHP_SAPI === 'cli') {
    // Parse command line arguments
    $options = getopt('', ['wikitext:', 'format:']);
    
    if (!isset($options['wikitext'])) {
        die("Usage: php mediawiki_parser.php --wikitext=\"'''bold''' text\" [--format=html|json]\n");
    }
    
    $format = $options['format'] ?? 'html';
    $wikitext = $options['wikitext'];
    
    try {
        $parser = new StandaloneParser();
        
        if ($format === 'json') {
            $result = $parser->parseWithMetadata($wikitext);
            echo json_encode($result, JSON_PRETTY_PRINT);
        } else {
            $result = $parser->parse($wikitext);
            echo $result;
        }
        echo "\n";
    } catch (Exception $e) {
        die("Error: " . $e->getMessage() . "\n");
    }
}